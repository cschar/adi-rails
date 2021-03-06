# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  street     :string
#  city       :string
#  zip        :string
#  state      :string
#  beds       :string
#  baths      :string
#  sq__ft     :string
#  sale_date  :datetime
#  price      :integer
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Transaction < ApplicationRecord
  geocoded_by :address   #setups up geocoder gem on this model and looks for address method

  #and call geocode using above setting after validation step
  # after_validation(:geocode , if: :address_changed?)

  # https://github.com/ankane/searchkick#geospatial-searches
  searchkick(locations: [:location])
  # Transaction.reindex to update elasticsearch

  def address
    [street, city, zip, state].compact.join(", ")
  end

  def address_changed?
    street_changed? || city_changed? || zip_changed? || state_changed?
  end

  def foo
    "heyoheyo"
  end

  def search_data
    attributes.merge location: {lat: latitude, lon: longitude}
  end
end
