class CreateSequencedMailerTables < ActiveRecord::Migration[7.0]
  def self.up
    create_table :mailing_sequences do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :mailing_sequences, :name, unique: true

    create_table :mailing_sequence_steps do |t|
      t.string :name, null: false
      t.integer :days_after_last_step, null: false
      t.integer :position, null: false
      t.references :mailing_sequence, null: false, foreign_key: true

      t.timestamps
    end

    create_table :mailing_sequence_owners do |t|
      t.references :mailing_sequence, null: false, foreign_key: true
      t.references :owner, polymorphic: true, null: false
      t.integer :current_step, null: false, default: 0
      t.datetime :last_email_sent_at
      t.datetime :canceled_at

      t.timestamps
    end
  end

  def self.down
    drop_table :mailing_sequences
    drop_table :mailing_sequence_steps
    drop_table :mailing_sequence_owners
  end
end
