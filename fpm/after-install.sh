cp /usr/local/bin/zeyple.conf.example /etc/

adduser --system --no-create-home --disabled-login zeyple

mkdir -p /var/lib/zeyple/keys

chmod 700 /var/lib/zeyple/keys

chown zeyple: /var/lib/zeyple/keys

cat >> /etc/postfix/master.cf <<CONF
zeyple    unix  -       n       n       -       -       pipe
  user=zeyple argv=/usr/local/bin/zeyple.py \${recipient}

localhost:10026 inet  n       -       n       -       10      smtpd
  -o content_filter=
  -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks,no_milters
  -o smtpd_helo_restrictions=
  -o smtpd_client_restrictions=
  -o smtpd_sender_restrictions=
  -o smtpd_recipient_restrictions=permit_mynetworks,reject
  -o mynetworks=127.0.0.0/8
  -o smtpd_authorized_xforward_hosts=127.0.0.0/8
CONF

cat >> /etc/postfix/main.cf <<CONF
content_filter = zeyple
CONF

cp zeyple.py /usr/local/bin/zeyple.py
chmod 744 /usr/local/bin/zeyple.py && chown zeyple: /usr/local/bin/zeyple.py

touch /var/log/zeyple.log && chown zeyple: /var/log/zeyple.log

postfix reload