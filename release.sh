#!/usr/bin/env bash
set +euo pipefail


check_images() {
    result="$(docker images|grep -E 'virtualdisk/ubuntu|virtualdisk/arch|ubuntu/debian')"
    if [[ "${result}" ]]; then
        echo "Existing local image(s) detected. Overwrite?"
        read -r answer
        case "${answer}" in
            Y)
                echo "Proceeding."
                ;;
            y)
                echo "Proceeding."
                ;;
            *)
                echo "Quitting."
                exit 0
        esac
    fi
}


build_and_upload() {
    # this is the buildx version of docker-compose build
    # docker buildx bake ubuntu --set "ubuntu".platform=linux/arm64 \
    #                    --set "debian".platform=linux/arm64 \
    #                    --set "arch".platform=linux/arm64

    declare -a distro=("ubuntu" "debian" "arch")
    for i in "${distro[@]}"; do
        docker buildx bake "${i}" --set "${i}".platform=linux/amd64
        # docker push "virtualdisk/${i}"
    done
}

main() {
    check_images
    build_and_upload
}

main
