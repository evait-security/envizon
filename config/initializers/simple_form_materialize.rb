# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.error_notification_class = 'alert alert-danger'
  config.button_class = 'btn'
  config.boolean_label_class = nil
  config.boolean_style = :inline
  config.item_wrapper_tag = :p

  config.wrappers :materialize_form, tag: 'div', class: 'input-field col', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :input
    b.use :label
    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_text, tag: 'div', class: 'input-field col', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :input, class: 'materialize-textarea' 
    b.use :label
    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_boolean, tag: 'p', class: 'col', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :input
    b.use :label
    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_toggle, tag: 'p', class: 'col switch', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly

    b.use :label
    b.wrapper tag: 'label' do |ba| 
      ba.use :input
      ba.use :tag, tag: 'span', class: 'lever'
    end
    
    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_radio_and_checkboxes, tag: 'div', class: 'col', error_class: 'has-error' do |b|
    b.use :html5
    b.optional :readonly
    b.use :label
    b.use :input
    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_file_input, tag: 'div', class: 'file-field input-field col', error_class: 'has-error' do |b|
    b.use :html5

    b.wrapper tag: :div, class: 'btn' do |ba| 
      ba.use :tag, tag: :span, text: :label_text
      ba.use :input
    end

    b.wrapper tag: :div, class: 'file-path-wrapper' do |ba|
      ba.use :tag, tag: :input, class: 'file-path validate', type: 'text', placeholder: 'Browse...'
    end

    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.wrappers :materialize_multiple_file_input, tag: 'div', class: 'file-field input-field col', error_class: 'has-error' do |b|
    b.use :html5
    
    b.wrapper tag: :div, class: 'btn' do |ba| 
      ba.use :tag, tag: :span, text: :label_text
      ba.use :input, multiple: true
    end

    b.wrapper tag: :div, class: 'file-path-wrapper' do |ba|
      ba.use :tag, tag: :input, class: 'file-path validate', type: 'text', placeholder: 'Upload one or more files'
    end

    b.use :error, wrap_with: { tag: 'small', class: 'error-block red-text text-darken-1' }
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
  end

  config.default_wrapper = :materialize_form
  config.wrapper_mappings = {
    text: :materialize_text,
    check_boxes: :materialize_radio_and_checkboxes,
    radio_buttons: :materialize_radio_and_checkboxes,
    file: :materialize_file_input,
    boolean: :materialize_toggle
  }
end
