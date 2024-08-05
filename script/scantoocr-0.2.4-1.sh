#!/usr/bin/env bash
set -eou pipefail

# Enabled for debugging
# set +x

# $1 = scanner device

# Resolution (dpi):
# 100,200,300,400,600
resolution=300
device=$1
date=$(date +%Y-%m-%d-%H-%M-%S)
filename_base=/scans/$date"-page"
output_file=$filename_base"%d.pnm"

# Import shell libraries
source ./libs/error.sh

# Check for required parameters
if [ -z "${device}" ]; then
  error "${LINENO}" "No device specified as arg1"
fi

# override environment, as brscan is screwing it up:
if [ -f /opt/brother/scanner/env.txt ]; then
  export $(grep -v '^#' /opt/brother/scanner/env.txt | xargs)
fi

if scanadf --device-name "$device" \
  --source "Automatic Document Feeder(centrally aligned)" \
  --resolution $resolution \
  --output-file $output_file 2>/dev/null; then

  echo "Scanning successful"
else
  error "${LINENO}" "Scanning failed"
fi

if gm convert "${filename_base}*.pnm" ${filename_base}.pdf ; then
  echo "Conversion from pnm to pdf successful"
else
  error "${LINENO}" "Conversion from pnm to pdf failed"
fi

if [ -f "${filename_base}"*.pnm ]; then
  echo "Removing temporary pnm files"
  rm "${filename_base}"*.pnm
fi

output_ocr_pdf="${filename_base}_ocr.pdf"

if ocrmypdf --rotate-pages \
  --clean \
  --quiet \
  "${filename_base}.pdf" \
  "${output_ocr_pdf}" ; then
  echo "OCR successful"
else
  error "${LINENO}" "OCR failed"
fi

rm "${filename_base}.pdf"

/opt/brother/scanner/brscan-skey/script/trigger_inotify.sh \
  "${SSH_USER}" \
  "${SSH_PASSWORD}" \
  "${SSH_HOST}" \
  "${SSH_PATH}" \
  "${output_ocr_pdf}"

/opt/brother/scanner/brscan-skey/script/sendtoftps.sh \
  "${FTP_USER}" \
  "${FTP_PASSWORD}" \
  "${FTP_HOST}" \
  "${FTP_PATH}" \
  "${output_ocr_pdf}"
