#!/usr/bin/env python
#-*- coding: UTF-8 -*- 

import requests
import json
import smtplib
import datetime
import sys
from email.mime.text import MIMEText
from email import encoders
from email.header import Header
from email.utils import parseaddr, formataddr
from requests.auth import HTTPDigestAuth

def getYesterday():
    today = datetime.date.today()
    oneday = datetime.timedelta(days=1)
    yesterday = today - oneday
    return str(yesterday)

def _format_addr(s):
    name, addr = parseaddr(s)
    return formataddr(( \
        Header(name, 'utf-8').encode(), \
        addr.encode('utf-8') if isinstance(addr, unicode) else addr))

to_addrs = ['ethan.xt.chen@mail.foxconn.com',
'jackie.jc.zhang@mail.foxconn.com',
'Nancy.jj.ren@mail.foxconn.com',
'john.y.jiao@mail.foxconn.com',
'herbie.hb.guo@mail.foxconn.com',
'sky.j.li@mail.foxconn.com',
'jenny.y.qiao@mail.foxconn.com',
'zhuo.quan@mail.foxconn.com',
'gavin.gf.li@mail.foxconn.com',
'snow.jx.xiong@mail.foxconn.com',
'paul.l.yang@mail.foxconn.com',
'yin-long.hu@mail.foxconn.com',
'jimmy.jp.chen@mail.foxconn.com',
'jasean.s.zhang@mail.foxconn.com',
'jubo.wei@mail.foxconn.com',
'qiu-peng.sun@mail.foxconn.com',
'JackYChen@fih-foxconn.com',
'JimmyJPChen@fih-foxconn.com',
'karen.cj.chu@mail.foxconn.com',
'xu-heng.liu@mail.foxconn.com',
'yao.zhang@mail.foxconn.com',
'clark.y.li@mail.foxconn.com',
'chris.pl.wang@mail.foxconn.com',
'super.sp.yin@mail.foxconn.com',
'kayla.j.wang@mail.foxconn.com',
'yue-jun.lu@mail.foxconn.com',
'ke-ming.liang@mail.foxconn.com',
'macintosh.zp.lee@mail.foxconn.com',
'jiang-wei.liu@mail.foxconn.com',
'ji-dong.mo@mail.foxconn.com',
'Jane.jj.cui@mail.foxconn.com',
'jackie.w.li@mail.foxconn.com',
'qi-luo.zhang@mail.foxconn.com',
'inge.yq.pan@mail.foxconn.com',
'damon.f.ma@mail.foxconn.com',
'ying-ying.yu@mail.foxconn.com',
'holy.hl.wang@mail.foxconn.com',
'snakox.lw.tong@mail.foxconn.com',
'stark.ss.chen@mail.foxconn.com',
'jakson.lf.zhang@mail.foxconn.com']

yesterday = getYesterday()
rest_api_uri = "http://gerrit.fihtdc.com/a/changes/?q=status:merged+owner:self+after:" + yesterday + "&o=CURRENT_REVISION"
response = requests.get(rest_api_uri,
             auth=HTTPDigestAuth("nj-app01", "DYgHIHf912MKHcyzQuraqwafkLSQ8EmeEq38wo9qtg"))
data = response.text
json_data = data[5:]  #remove invalid data
json_string = json.dumps(json_data)
dict_lists = json.loads(json_data)

if len(dict_lists) == 0:
    sys.exit()

mail_body = u'Dear All：\n\n'
mail_body += u'下面是 nj-app01 用户昨天所有的提交，共计' + str(len(dict_lists)) + u'笔，请相关 owner 注意验证，Thanks！\n\n'

for i in dict_lists:
    mail_body += i['subject']
    mail_body += "\n"
    mail_body += i['project']
    mail_body += " " * 5
    mail_body += i['branch']
    mail_body += " " * 5
    mail_body += i['current_revision']
    mail_body += "\n"
    mail_body += "-" * 60
    mail_body += "\n"

from_addr = "daily-commits-summary@zzdc.com"
#password = "Foxconn123"
#to_addr = "zhuo.quan@mail.foxconn.com"
smtp_server = "mailgw.fihtdc.com"

msg = MIMEText(mail_body, 'plain', 'utf-8')
msg['From'] = _format_addr(u'昨天的提交 <%s>' % from_addr)
#msg['To'] = _format_addr(u'管理员 <%s>' % to_addr)
msg['Subject'] = Header(u'nj-app01 昨天所有的提交', 'utf-8').encode()

server = smtplib.SMTP(smtp_server, 25)
#server.starttls()
server.set_debuglevel(1)
#server.login(from_addr, password)
server.sendmail(from_addr, to_addrs, msg.as_string())
server.quit()
