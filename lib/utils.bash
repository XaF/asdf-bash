#!/usr/bin/env bash

set -euo pipefail

TOOL_NAME="bash"
TOOL_TEST="bash --version"

curl_opts=(
	--fail
	--silent
	--show-error
	--location
)

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
	local bash_version_archives
	bash_version_archives=$(
		curl "${curl_opts[@]}" 'https://ftp.gnu.org/gnu/bash/' |
			sed -ne 's/.*>\(bash-[^<]*\.tar\.gz\)<.*/\1/p' |
			grep -v -- '-doc-'
	)
	local version
	for version in $bash_version_archives; do
		version=${version%.tar.gz}
		version=${version#bash-}

		version_major=${version%%\.*}
		if [[ $version_major -lt 3 ]]; then
			# Bash 1.x and 2.x are not compilable on modern systems,
			# so we consider them not available
			continue
		fi

		echo "$version"
	done
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="https://ftp.gnu.org/gnu/bash/bash-${version}.tar.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}"
	local bin_path="$install_path/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	local version_major
	version_major="$(echo "$version" | cut -d. -f1)"

	local configure_opts
	configure_opts=(
		"--config-cache"
		"--prefix=$install_path"
		"--exec-prefix=$install_path"
	)

	if [[ $version_major -eq 3 ]]; then
		# For bash 3.x, we need to use the installed readline library
		# and enable extended globbing, or it will fail to compile
		configure_opts+=(
			"--with-installed-readline"
			"--enable-extended-glob"
		)
	fi

	(
		cd "$ASDF_DOWNLOAD_PATH"
		./configure "${configure_opts[@]}"

		make -j${ASDF_CONCURRENCY:-1} install

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$bin_path/$tool_cmd" || fail "Expected $bin_path/$tool_cmd to be executable."

		chmod -R +w "$ASDF_DOWNLOAD_PATH"

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
