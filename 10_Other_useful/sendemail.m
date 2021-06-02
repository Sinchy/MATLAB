function sendemail(subjecttitle,content)
mail = 'tan_shiyong@126.com';  % ①邮箱地址
password = 'Sinchy2012'; % ②密码

% 服务器设置
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.126.com'); % ③SMTP服务器
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
sendmail(mail,subjecttitle,content);
disp('sent!');
end

