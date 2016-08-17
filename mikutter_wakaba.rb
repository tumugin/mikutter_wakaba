# -*- coding: utf-8 -*-

Plugin.create(:mikutter_wakaba){
  class Gdk::MiraclePainter
    alias render_background_orig render_background
    @@wakaba = nil

    def self.load_wakaba
      @@wakaba = Gdk::Pixbuf.new("#{File.dirname(__FILE__)}/wakaba.png")
    end

    def render_background(context)
      render_background_orig(context)
      #初心ツイッタラー標識をつける(アカウント取得から1年未満の者に表示する)
      #1年=31536000sec
      if (Time.now - message[:user][:created]) >= 31536000
        return
      end
      if !@@wakaba
        Gdk::MiraclePainter::load_wakaba()
      end
      context.save {
        context.translate(width - @@wakaba.width, (height - @@wakaba.height) >= 0 ? height - @@wakaba.height : 0)
        context.set_source_pixbuf(@@wakaba)
        context.paint(0.2)
      }
    end

  end
}
