class UncoupleEventFromLocation < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        remove_column :events, :location_id
        add_column :events, :city, :string
      end

      dir.down do
        add_column :events, :location_id, :integer
      end
    end
  end
end
