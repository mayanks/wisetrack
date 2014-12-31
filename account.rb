# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  domain     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  meta       :text
#  storage    :string(255)      default("S3")
#  ip         :string(255)
#

class Account < ActiveRecord::Base
  attr_accessible :domain, :name, :exp_user, :exp_password, :exp_server, :exp_port, :exp_handler, :account_preferences, :storage, :ip, :adc_uuid
  attr_accessor :exp_user, :exp_password, :account_preferences, :adc_uuid

  validates_presence_of :domain, :name
  validates_uniqueness_of :domain
  validates :domain, :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "Only letters allowed" }
  validate :unique_domain_name, :on => :create

  has_many :users
  has_many :feeds, :dependent => :destroy
  has_one  :s3_bucket, :dependent => :destroy
  has_many :medias
  has_many :videos, :conditions => {:category => MEDIA_CATEGORY_VIDEO}
  has_many :rescues, :class_name => "Video", :conditions => {:category => MEDIA_CATEGORY_RESCUE}
  has_many :subtitles
  has_many :firmwares
  has_many :graphics
  has_many :signatures

  serialize :meta, Hash

  def unique_domain_name
    if Rails.configuration.respond_to?('s3')
      s = S3Bucket.new
      buckets = s.s3_admin.buckets
      buckets.each do |b|
        if b.name =~ /amagicloud-#{self.domain}/i
          self.errors.add(:domain, "Domain name is in use")
          break
        end
      end
    end
  end

  def exp_user
    self.meta.nil? ? "" : self.meta[:exp_user]
  end

  def exp_password
    self.meta.nil? ? "" : self.meta[:exp_password]
  end

  def exp_dir
    Rails.configuration.expe_upload_dir + "/" + self.domain
  end

  def exp_over_s3?
    self.meta and self.meta[:exp_user]
  end

  def is_storage_s3?
    return self.storage == STORAGE_S3
  end

  def exp_path(file)
    if self.exp_over_s3?
      user = self.meta[:exp_user]
      pwd = self.meta[:exp_password]
      server = self.meta[:exp_server]
      port = self.meta[:exp_port]

      return "exp://#{user}:#{pwd}@#{server}:#{file}"
    else
      return "exp://#{Rails.configuration.hostname}/#{self.domain}/#{file}"
    end
  end

  def has_adc_uuid?
    !self.meta.nil? and self.meta[:adc_uuid].present?
  end

  def adc_uuid
    self.meta[:adc_uuid]
  end

  def dartbus_groups
    groups = Hash.new
    groups['groups'] = Array.new
    groups['groups'] << {"name" => "uni-ver-sal", "code" => "uni-ver-sal", "parent_code" => "", "id" => 1}
    self.feeds.each do |feed|

      next unless feed.satellite_tx?

      region = feed.feed_region
      rcode = region.dartbus_code
      groups['groups'] << {"name" => rcode, "code" => rcode, "parent_code" => "", "id" => region.dartbus_id}
      
      feed.regions.includes('region').each do |region|
        rcode = region.dartbus_code
        parent = region.region.blank? ? "" : region.region.dartbus_code
        groups['groups'] << {"name" => rcode, "code" => rcode, "parent_code" => parent, "id" => region.dartbus_id}
      end

      feed.headends.includes('region').each do |headend|
        next if headend.region.nil?
        code = headend.dartbus_code
        parent = headend.region.dartbus_code
        groups['groups'] << {"name" => code, "code" => code, "parent_code" => parent, "id" => headend.dartbus_id}
      end

    end

    return groups
  end
end
