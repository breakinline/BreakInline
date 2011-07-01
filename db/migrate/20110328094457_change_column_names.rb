class ChangeColumnNames < ActiveRecord::Migration
  def self.up
    rename_column :orders, :profileId, :profile_id
    rename_column :orders, :locationId, :location_id
    remove_column :orders, :comment
    rename_column :order_items, :menuItemId, :menu_item_id
    rename_column :order_items, :orderId, :order_id
    rename_column :order_items, :parentOrderItemId, :parent_order_item_id
    rename_column :order_payments, :orderId, :order_id
    rename_column :choices, :groupKey, :group_key
    rename_column :options, :groupKey, :group_key
    rename_column :order_payments, :cardType, :card_type
    rename_column :order_payments, :cardNo, :card_no
    rename_column :order_payments, :expirationMonth, :expiration_month
    rename_column :order_payments, :expirationYear, :expiration_year
    rename_column :order_items, :itemType, :item_type
    rename_column :orders, :pickupAt, :pickup_at
    rename_column :orders, :subTotal, :sub_total
    rename_column :orders, :taxTotal, :tax_total
    rename_column :locations, :taxRate, :tax_rate
  end

  def self.down
  end
end
