require 'yaml'

class EnvizonCpe
  def initialize
    @root = YAML.load_file(Rails.root.join('config', 'cpe.yml'))
  end

  def name(client)
    value(client.cpe, @root[:name])
  end

  def group(client)
    os = client.ostype.strip.downcase
    return ['Printer'] if os.include?('printer')
    return ['Net Devices'] if %w[router firewall switch].any? { |key| os.include?(key) }
    return ['Storage'] if os.include?('storage')
    result = []
    result.push(value(client.cpe, @root[:group]))
    result.push(value(client.cpe, @root[:group_detailed]))
    result.uniq
  end

  def icon(client)
    os = client.ostype.strip.downcase
    return '<i class="fas fa-print"></i>' if os.include?('printer')
    return '<i class="fas fa-shield-alt"></i>' if %w[router firewall switch].any? { |key| os.include?(key) }
    return '<i class="fas fa-hdd"></i>' if os.include?('storage')
    "<i class=\"fab fa-#{value(client.cpe, @root[:icon])}\"></i>"
  end

  def value(input_value, root)
    input = input_value.respond_to?(:split) ? input_value.split(':') : input_value
    input.flatten!
    # remove trailing version if last 'field' is a number
    # because that wouldn't work (well) as a symbol
    input.pop if input.last =~ /\A\d+\Z/
    r = root[input.shift.to_sym] if input.present?
    r ||= root[:_default].present? ? root[:_default] : nil
    if r.is_a?(String)
      r
    else
      r = value(input, r) if r
      r || root[:_default]
    end
  end
end
