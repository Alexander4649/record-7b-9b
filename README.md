応用課題フェーズ
* 課題7b グループ作成機能
* 課題8b グループ入退会機能
* 課題9b グループメール機能

【&nbsp;】：半角スペースと同じサイズの空白
【&thinsp;】：&nbsp;の空白より小さい空白
【&ensp;】：半角スペースより間隔がやや広い空白
【&emsp;】：全角スペースとほぼ同じサイズの空白

〜〜〜課題9b グループメール機能〜〜〜
* メーラーを生成 => rails generate mailer ContactMailer
railsコマンド(rails generate)で生成します。 ContactMailer は任意クラス名。
今回はお問い合わせ関係のメール送信機能を作成したいためContactMailerです。

* メールサーバー設定
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp #SMTP」とは「Simple Mail Transfer Protocol（シンプル・メール・トランスファー・プロトコル）
  config.action_mailer.smtp_settings = {
    port:                 587, #=> SMTPサーバーのポート番号
    address:              'smtp.gmail.com', #=> SMTPサーバーのホスト名
    domain:               'gmail.com', #=> HELOドメイン
    user_name:            'メルアド',#=> メール送信に使用するgmailのアカウント
    password:             'アプリパスワード',#=> メール送信に使用するgmailのパスワード
    authentication:       'login',#=> 認証方法
    enable_starttls_auto: true#=> メールの送信にTLS認証を使用するか
  }

application_mailerには全メーラー共通の設定を、
sample_mailerにはメーラー個別の設定をします。

* コントローラ記述
def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @group = Group.find(params[:group_id])
    group_users = @group.users
    @mail_title = params[:mail_title]
    @mail_content = params[:mail_content]
    ContactMailer.send_mail(@mail_title, @mail_content,group_users).deliver
  end
  
def send_mailではvies/groups/new_mail.htmlのform_withで入力された値を受け取っています。
@mail_title = params[:mail_title]
@mail_content = params[:mail_content]
そして、その値をContactMailerのsend_mailアクションへ渡しています。

* 