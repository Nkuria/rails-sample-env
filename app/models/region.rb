# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  parent_id  :integer
#
# Indexes
#
#  index_regions_on_company_id  (company_id)
#  index_regions_on_parent_id   (parent_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#  parent_id   (parent_id => regions.id)
#
class Region < ApplicationRecord
  has_closure_tree order: 'id'

  belongs_to :company
  has_many :customers

  scope :parent_regions, -> { where(parent_id: nil).order(:id) }
  scope :parent_regions_without_self, ->(id) { parent_regions.where.not(id: id) }
  scope :sub_regions, -> { where.not(parent_id: nil).order(:parent_id) }
end
