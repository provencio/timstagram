class RemovePaperclipImageFromPosts < ActiveRecord::Migration[8.0]
  # Run `rake paperclip:migrate_to_active_storage` before this migration if you
  # have existing uploads under public/system that still need to be carried over.
  def change
    remove_column :posts, :image_file_name,    :string
    remove_column :posts, :image_content_type, :string
    remove_column :posts, :image_file_size,    :integer
    remove_column :posts, :image_updated_at,   :datetime
  end
end
