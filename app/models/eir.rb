require "prawn"
require "prawn/qrcode"

class Eir < ApplicationRecord
  belongs_to :container

  def generate_pdf
    Prawn::Document.new do |pdf|
      # pdf.stroke_color "00008B"
      # pdf.fill_color "00008B"
      pdf.image "#{Rails.root}/app/assets/images/logo.jpeg", width: 200, position: :center
      pdf.move_down 10
      pdf.text "EIR - Logística y Transporte Sago", size: 20, style: :bold, align: :center, color: "00008B"
      pdf.move_down 10
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      pdf.text "#{ container.number }", style: :bold, size: 16, align: :center
      # pdf.text "Date: #{date.strftime('%Y-%m-%d %H:%M')}"
      pdf.move_down 20
      pdf.text "Operador: #{ operator }"
      pdf.move_down 10
      pdf.text "Transporte: #{ transport }"
      pdf.move_down 10
      pdf.text "Placas: #{ plate }"
      pdf.move_down 10
      pdf.text "Número económico: #{ fleet_number }"
      pdf.move_down 10
      pdf.text "Dueño de la Carga: #{ container.cargo_owner }"
      pdf.move_down 10
      pdf.text "Tipo de Contenedor: #{ container.container_type }"
      pdf.move_down 10
      pdf.text "Tamaño: #{ container.size }"
      pdf.move_down 10
      entrada = container.moves.find_by(move_type: "Entrada")
      if entrada.present?
        pdf.text "Fecha de Entrada: #{entrada.created_at.in_time_zone('America/Mexico_City').strftime('%d/%b/%Y %I:%M %p')}"
      else
        pdf.text "Fecha de Entrada: No disponible"
      end
      pdf.move_down 10
      salida = container.moves.find_by(move_type: "Salida")
      if salida.present?
        pdf.text "Fecha de Salida: #{salida.created_at.in_time_zone('America/Mexico_City').strftime('%d/%b/%Y %I:%M %p')}"
      else
        pdf.text "Fecha de Salida: No disponible"
      end
      pdf.move_down 10
      pdf.text "Emisión: #{Time.current.in_time_zone('America/Mexico_City').strftime('%d/%b/%Y %I:%M %p')}"
      pdf.move_down 20
      pdf.text "Firma del Operador: __________________________", position: :center
      pdf.move_down 20

      # Generate and embed the QR code
      pdf.move_down 30
      qr_code = generate_qr_code
      pdf.image StringIO.new(qr_code.to_blob), scale: 0.5

      # Save the PDF to a file
      # pdf.render_file "eir_#{container.number}.pdf"
    end
  end
  def generate_qr_code
    qr = RQRCode::QRCode.new("https://container-yard-2657e8869d5b.herokuapp.com/containers/#{container_id}")
    qr.as_png(size: 200)
  end
end
