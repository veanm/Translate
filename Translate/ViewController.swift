//
//  ViewController.swift
//  Translate
//
//  Created by Robert O'Connor on 16/10/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var textToTranslate:         UITextView!
    @IBOutlet weak var translatedText:          UITextView!
    @IBOutlet weak var languageSelection:       UIPickerView!
    @IBOutlet weak var indicator:               UIActivityIndicatorView!
    @IBOutlet weak var translateButton:         UIButton!
    
    @IBOutlet weak var TranslateFromSelected:   UILabel!
    @IBOutlet weak var TranslateToSelected:     UILabel!
                    var Languages =             ["French", "English", "Irish", "Turkish"];
                    let LangDict =              ["French":"fr", "English":"en", "Irish":"ga", "Turkish":"tr"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Languages = Languages.sort();
        TranslateFromSelected.text = Languages[0];
        TranslateToSelected.text   = Languages[0];
        makePretty_ish();
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard");
        view.addGestureRecognizer(tap);
    }
    
    func makePretty_ish(){
        TranslateFromSelected.clipsToBounds = true;
        TranslateFromSelected.layer.cornerRadius = 10;
        TranslateToSelected.clipsToBounds = true;
        TranslateToSelected.layer.cornerRadius = 10;
        textToTranslate.clipsToBounds = true;
        textToTranslate.layer.cornerRadius = 10;
        translatedText.clipsToBounds = true;
        translatedText.layer.cornerRadius = 10;
        translateButton.clipsToBounds = true;
        translateButton.layer.cornerRadius = 10;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func translate(sender: AnyObject) {
        
        let str = textToTranslate.text
        let escapedStr = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet());
        
        if(textToTranslate.text == ""){
            translatedText.text = "ERROR: No text entered!";
            return;
        }
        
        if(LangDict[TranslateFromSelected.text!] == LangDict[TranslateToSelected.text!]){
            translatedText.text = textToTranslate.text!;
            return;
        }
        
        var translateCommand = LangDict[TranslateFromSelected.text!];
        translateCommand! += "|";
        translateCommand! += LangDict[TranslateToSelected.text!]!;
        
        let langStr = (translateCommand!).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let urlStr:String = ("http://api.mymemory.translated.net/get?q="+escapedStr!+"&langpair="+langStr!)
        
        let url = NSURL(string: urlStr)
        
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        //var data = NSMutableData()var data = NSMutableData() //wat?
        
        //let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        
        var result = "<Translation Error>"
        
//        public func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask{
//        
//        } //pasted in for reference to try figure out how it works
        
//        NSURLSession.dataTaskWithRequest(request) {
//            
//        } //doesn't make any sense!
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            self.indicator.stopAnimating()
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    
                    let jsonDict: NSDictionary!=(try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if(jsonDict.valueForKey("responseStatus") as! NSNumber == 200){
                        let responseData: NSDictionary = jsonDict.objectForKey("responseData") as! NSDictionary
                        
                        result = responseData.objectForKey("translatedText") as! String
                    }
                }
                
                self.translatedText.text = result
            }
        }
        
    }
    
    // MARK stuff for picker thing
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        //code
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //code
        return Languages.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //code
        return Languages[row];
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //code
        if(pickerView.tag == 0){
            TranslateFromSelected.text = Languages[row];
        }
        if(pickerView.tag == 1){
            TranslateToSelected.text = Languages[row];
        }
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
}

