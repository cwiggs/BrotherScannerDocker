# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v1.4.1] - 2023-09-23
### Changed
- Only add $USERNAME if the user doesn't exist.

## [v1.4.0] - 2023-08-01
### Changed
- Updated the ocr script so it deletes all the files after it uploads them via ftps.

## [v1.3.0] - 2023-08-01
### Changed
- Updated the github actions so it also works on tags.

## [1.2.0] - 2023-08-01
### Added
- github actions that will publish the docker image to the github registry.

### Changed
- Cleanup dockerfile.
- Move things from the cmd script in the dockerfile.
- Move brother scanner scripts inside the image.

## [1.1.0] - 2023-09-06
### Changed
- Upgrade to ubuntu 20.04
- Use lftp instead of curl for uploading to ftps.
- Use ocrmypdf to create a ocr pdf file when the ocr script is ran.
