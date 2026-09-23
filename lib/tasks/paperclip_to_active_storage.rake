namespace :paperclip do
  desc 'Attach legacy Paperclip uploads (public/system) to Active Storage'
  task migrate_to_active_storage: :environment do
    unless Post.column_names.include?('image_file_name')
      abort 'The Paperclip columns are already gone - nothing to migrate.'
    end

    migrated = 0
    skipped  = 0

    Post.where.not(image_file_name: [nil, '']).find_each do |post|
      if post.image.attached?
        skipped += 1
        next
      end

      file_name = post.read_attribute(:image_file_name)
      id_partition = format('%09d', post.id).scan(/\d{3}/).join('/')
      path = Rails.root.join('public', 'system', 'posts', 'images', id_partition, 'original', file_name)

      unless File.exist?(path)
        warn "Post #{post.id}: missing #{path}"
        skipped += 1
        next
      end

      File.open(path) do |file|
        post.image.attach(
          io: file,
          filename: file_name,
          content_type: post.read_attribute(:image_content_type)
        )
      end

      migrated += 1
    end

    puts "Attached #{migrated} image(s), skipped #{skipped}."
    puts 'Verify the uploads, then run `bin/rails db:migrate` to drop the Paperclip columns.'
  end
end
