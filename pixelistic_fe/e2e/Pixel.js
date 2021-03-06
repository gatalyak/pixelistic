module.exports = {
  'Pixel' :  (browser) => {
    browser
      .url('https://pixelistic.icu/')
      .assert.visible(".sign-in")
      //Sign in
      //Set incorrect value
      .setValue('#inp-email', 'v.dvoryan@gmail.com')
      .setValue('#inp-password', '1234567')
      .submitForm('.form')
      .waitForElementVisible('.err-msg',10000)
      .assert.containsText('.err-msg', 'Email or password is incorrect')
      .pause(1000)
      .clearValue('#inp-password')
      //set correct value
      .setValue('#inp-password', '123456')
      .submitForm('.form')
      .waitForElementVisible('.post',10000)
      //feed
      .assert.elementPresent(".logo-link")
      .assert.elementPresent(".post")
      .assert.elementPresent(".feed-aside ")
      .assert.elementPresent(".followings-list")
      .assert.elementPresent(".footer")        
      // add like
      .click('.like input')
      .pause(2000)
      .click('.like input')
      .pause(2000)
      //add comment
      .setValue('textarea[type=text]', 'Nice :)')
      .pause(2000)
      .keys('\uE007')
      //check buttons
      .pause(2000)
      .click('.bottom-nav button:nth-child(2)')
      .pause(1000)
      .click('.bottom-nav button:nth-child(3)')
      .pause(1000)
      .click('.bottom-nav button:nth-child(4)')
      .pause(1000)
      .click('.bottom-nav button:nth-child(1)')
      .pause(1000)
      //add to favorite
      .click('.chip')
      .pause(1000)
      .waitForElementVisible('.exp-details',10000)
      .assert.elementPresent(".exp-details")
      .click('.exp-details .like input')
      .pause(1000)
      .click('.bottom-nav button:nth-child(2)')
      .pause(1000)
      .click('.exp-details .like input')
      .pause(1000)
      .click('.bottom-nav button:nth-child(1)')
      .pause(1000)
      .click('.exp-details button:first-child')
      .pause(1000)
      //user profile
      .waitForElementVisible('.photo-wrapper',10000)
      .click('.photo-wrapper')
      .pause(1000)
      .waitForElementVisible('.post-cont',10000)
      .assert.elementPresent(".photo-cont")
      .assert.elementPresent(".post-header")
      .assert.elementPresent(".likes-panel")
      .assert.elementPresent(".date")
      .assert.elementPresent(".text-field")        
      .click('.like input')
      .pause(2000)
      .click('.like input')
      .pause(2000)
      .keys('\uE00C')
      .pause(1000)
      //my profile
      .click('.extension-icon')
      .pause(1000)
      .click('.menu-list ul a:first-child li')
      .waitForElementVisible('#dashboard-btn',10000)
      .pause(2000)
      //add name
      .moveToElement('body', 0, 0)
      .pause(1000)
      .click('#dashboard-btn')
      .pause(2000)
      .waitForElementVisible('form .form', 10000)
      .setValue('#inp-name', 'Vitalii Dvorian')
      .pause(1000)
      .click('.form button:first-child')
      .pause(2000)
      //delete name
      .click('#dashboard-btn')
      .pause(2000)
      .waitForElementVisible('form .form', 10000)
      .clearValue('#inp-name')
      .setValue('#inp-name',' ')
      .pause(1000)
      .click('.form button:first-child')
      .pause(2000)
      //Add new photo
      .click('.extension-icon')
      .pause(2000)
      .click('.menu-list ul a:nth-child(3) li')
      .waitForElementVisible('.empty-photo',10000)
      .pause(2000)
      .setValue('input#file-input', require('path').resolve(__dirname + '/photo.jpg'))
      .pause(2000)
      // PhotoEditor
      .click('.modal-btn')
      .pause(2000)
      .waitForElementVisible('.drawCanvas', 10000)
      // filters
      .setValue('.sliders .filter:nth-child(1) input[type="range"]', new Array(50).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(2) input[type="range"]', new Array(1).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(3) input[type="range"]', new Array(15).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(4) input[type="range"]', new Array(15).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(5) input[type="range"]', new Array(150).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(6) input[type="range"]', new Array(20).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(7) input[type="range"]', new Array(100).fill(browser.Keys.RIGHT_ARROW))
      .setValue('.sliders .filter:nth-child(8) input[type="range"]', new Array(50).fill(browser.Keys.RIGHT_ARROW))
      .pause(3000)
      .click('.photo-editor-btn:last-child')
      .waitForElementVisible('.btn-upload', 10000)
      .pause(3000)
      // add text to photo
      .click('.modal-btn')
      .pause(2000)
      .waitForElementVisible('.drawCanvas', 10000)
      .setValue('.textField', 'Pixel team')
      .setValue('.addTextSet:nth-child(3)', '90')
      .setValue('.addTextSet:nth-child(4)', '140')
      .setValue('.addTextSet:nth-child(5)', '100')
      .pause(2000)
      .click('.addTextBtn')
      .pause(2000)
      .click('.photo-editor-btn:last-child')
      .pause(2000)
      .click('.btn-upload')
      .waitForElementVisible('.post-info', 10000)
      .pause(1000)
      // Description
      .setValue('.post-info textarea:last-child', 'My photo')
      .setValue('.location-autocomplete input', 'Lviv')
      .waitForElementVisible('.variants', 10000)
      .pause(3000)
      .click('.search-loc:first-child')
      .pause(2000)
      .click('.save-btn')
      .pause(5000)
      //delete photo
      .click('.user-image:first-child')
      .waitForElementVisible('.likes-panel > button', 10000)
      .pause(1500)
      .click('.likes-panel > button')
      .pause(2000)
      //feed
      .click('.extension-icon')
      .pause(1000)
      .click('.menu-list ul a:nth-child(2) li')
      .waitForElementVisible('.post',10000)
      .pause(2000)
      .click('.notifications-icon')
      .pause(2000)
      //sing-out
      .click('.extension-icon')
      .pause(1000)
      .click('.menu-list ul > li')
      .waitForElementVisible('.sign-in',10000)
      .pause(2000)
      .end();
  }
};
