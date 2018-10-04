//
//  DetailViewController.swift
//  engmyan
//
//  Created by New Wave Technology on 7/10/18.
//  Copyright © 2018 S16. All rights reserved.
//

import Cocoa
import WebKit

class DetailViewController: NSViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    public var scale: Int = 1 {
        didSet {
            self.reloadData()
        }
    }
    
    public var data: DictionaryItem? {
        didSet {
            self.reloadData()
        }
    }
    
    private func reloadData() {
        if let item = self.data {
            let html = self.getDefinitionHtml(item: item, scale: Float(self.scale))
            self.webView?.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
        }
    }
    
    private func getDefinitionHtml(item: DictionaryItem, scale: Float) -> String {
        let fontSizeSmall = Int(8 + (2 * scale))
        let fontSizeNormal = Int(12 + (2 * scale))
        
        var html = "<!DOCTYPE html>"
        html += "<html lang=\"en\">"
        html += "<head>"
        html += "<meta content=\"text/html; charset=utf-8\" http-equiv=\"content-type\">"
        html += "<meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=yes, width=device-width\" />"
        html += "<meta name=\"Keywords\" content=\"\">"
        html += "<style type=\"text/css\">"
        html += "@font-face {font-family: 'Myanmar Text';src: url('./mmrtext.ttf');font-weight: normal;font-style: normal;}"
        html += "body,div,h1,h2,h3,input,textarea {font-family:\"Myanmar Text\";-webkit-font-smoothing: antialiased!important;text-rendering: optimizeLegibility;}"
        html += "p {margin:0pt;line-height:180%;font-size:\(fontSizeSmall)pt;}"
        html += "p.desc , p.synonym {margin-left:9px;}"
        html += "h2 {color: red;font-weight: bold;font-size: \(fontSizeNormal)pt;}"
        html += "h3 {color: #8080C0;font-weight: bold;font-size: \(fontSizeSmall)pt;}"
        html += "a {color: #000;text-decoration: none;border-bottom: 1px dotted #808080;}"
        html += "</style>"
        if let title = item.title, title != "" {
            html += "<title>\(title)</title>"
        } else {
            html += "<title>Untitled</title>"
        }
        html += "</head>"
        html += "<body>"
        if let definition = item.definition {
            html += "\(definition)"
        }
        
        if let synonym = item.synonym, synonym != "" {
            html += "<hr />"
            html += "<h3>Synonym</h3>"
            html += "<p class=\"synonym\">\(synonym)</p>"
        }
        
        if let picture = item.pictureBase64, let word = item.word {
            html += "<hr />"
            html += "<img src='\(picture)' alt='\(word)' />"
        }
        
        html += "</html>"
        return html
    }
}
