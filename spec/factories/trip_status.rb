FactoryGirl.define do
  factory :trip_status do
    name      TripStatus::STATUS_NEW
    active    true
  end
end