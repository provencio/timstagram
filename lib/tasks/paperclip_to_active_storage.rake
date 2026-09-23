namespace :paperclip do
  desc 'Attach legacy Paperclip uploads (public/system) to Active Storage'
  task migrate_to_active_storage: :environment do
    unless Post.column_names.include?('image_file_name')
      abort 'The Paperclip columns are already gone - nothing to migrate.'
    end

    root = Rails.root.join('public', 'system', 'posts', 'images')
    migrated = 0
    skipped  = 0

    Post.where.not(image_file_name: [nil, '']).find_each do |post|
      if post.image.attached?
        skipped += 1
        next
      end

      # The stored file name is whatever the uploader sent years ago, so keep
      # it to a single path segment and confirm the result is still inside
      # public/system before opening it.
      file_name = File.basename(post.read_attribute(:image_file_name).to_s)
      id_partition = format('%09d', post.id).scan(/\d{3}/).join('/')
      path = root.join(id_partition, 'original', file_name)

      unless path.to_s.start_with?("#{root}/") && File.file?(path)
        warn "Post #{post.id}: no readable file at #{path}"
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
