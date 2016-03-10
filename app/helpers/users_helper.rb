# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  email             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string(255)
#  remember_digest   :string(255)
#  admin             :boolean          default(FALSE)
#  activation_digest :string(255)
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

module UsersHelper
  # 引数で与えられたユーザーのgravatar画像を返す
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?  s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
