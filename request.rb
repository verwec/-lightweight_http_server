class Request
  def initialize(raw_request)
    @raw_request = raw_request
  end

  def headers
    @raw_request.lines.inject({}) do |headers, line|
      return headers if line == "\r\n"
      raw_header, value = line.split
      header =  raw_header.delete(":", "").downcase.to_sym
      headers[header] = value
      headers
    end
  end

  def path
    headers.fetch(:get)
  end

  def method
    @raw_request.lines[0].split.first
  end

  def version
    @raw_request.lines[0].split.last
  end
end

