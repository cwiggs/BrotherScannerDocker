user=$1
password=$2
address=$3
filepath=$4
file=$5

cd /scans

if [ -z "${user}" ] || [ -z "${password}" ] || [ -z "${address}" ] || [ -z "${filepath}" ] || [ -z "${file}" ]; then
  echo "FTP environment variables not set, skipping ftp upload trigger."
else
  if lftp -e "set ssl:verify-certificate no; cd "${filepath}"; mput "${file}"; quit" \
    -u "${user}","${password}" \
    "${address}" ; then
    echo "Uploading to ftp server ${address} successful."
  else
    echo "Uploading to ftp failed while using curl"
    echo "user: ${user}"
    echo "address: ${address}"
    echo "filepath: ${filepath}"
    echo "file: ${file}"
    exit 1
  fi

  # Delete file after upload.
  if ! rm -f "${file}" ; then
    echo "Deleting file ${file} failed."
    exit 1
  fi
fi

