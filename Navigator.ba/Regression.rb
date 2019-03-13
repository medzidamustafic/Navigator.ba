require 'capybara'
require 'capybara/rspec'
require "selenium-webdriver"
require 'rspec'
require 'capybara/selenium/extensions/scroll'

Capybara.default_driver = :selenium_chrome
Capybara.ignore_hidden_elements = false

RSpec.describe 'Regression test', type: :feature do

  before(:each) do
    visit 'https://www.navigator.ba/#/categories'
  end

  it 'zoom the map' do
    find('.leaflet-control-zoom-in').click
    expect(page).to have_css("img[src*='11932.png")
    find('.leaflet-control-zoom-out').click
    expect(page).to have_css("img[src*='5966.png")
  end

  it 'create place' do
    find('#ember566').click
    fill_in 'poi_name', with: 'Biljna apoteka'
    fill_in "poi_city_name", with: 'Sarajevo'
    fill_in "poi_zip_code", with: '71000'
    fill_in "poi_place_id", with: 'Aleja Lipa'
    fill_in "poi_house_number", with: '33'
    fill_in "poi_description", with: 'Domaća biljna apoteka'
    find_button('Odaberite kategoriju').click
    find('.span3 option[value="11"]').select_option
    find('.span3 option[value="203"]').select_option
    execute_script("arguments[0].scrollIntoView();", page.find('#working_hours_0_0', visible: false))
    execute_script("arguments[0].value='8';", page.find('#working_hours_0_0', visible: false))
    execute_script("arguments[0].value='16';", page.find('#working_hours_0_1', visible: false))
    execute_script("arguments[0].click();", page.find("button.btnAddWorkingHours", visible: false))
    execute_script("arguments[0].click();", page.find("#btn_day_sat", visible: false))
    execute_script("arguments[0].click();", page.find("#btn_day_sun", visible: false))
    execute_script("arguments[0].value='9';", page.find('#working_hours_0_0', visible: false))
    execute_script("arguments[0].value='12';", page.find('#working_hours_0_1', visible: false))
    execute_script("arguments[0].value='+38762345678';", page.find('#poi_phone', visible: false))
    execute_script("arguments[0].value='www.biljnaapoteka.ba';", page.find('#poi_web', visible: false))
    execute_script("arguments[0].checked = true;", page.find("#poi_has_wifi", visible: false))
    execute_script("arguments[0].value='apoteka123';", page.find('#poi_wifi_pass', visible: false))
    execute_script("arguments[0].value='Apoteka';", page.find('#poi_wifi_ssid', visible: false))
    execute_script("arguments[0].checked = true;", page.find("#poi_accepts_credit_cards", visible: false))
    find_button('Odaberite kategoriju').native.send_keys(:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab)
    fill_in "poi_comment", with: 'Proizvodi vrhunske kvalitete.'
    find_button("Kreiraj", visible: false).click
    expect(page).to have_text "Biljna apoteka"
  end

  xit 'create button disabled, exit input form, create with required fields' do
    find('#ember566').click
    find_button('Odaberite kategoriju').native.send_keys(:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab)
    find_button("Kreiraj", visible: false).click
    expect(page).to have_text "Forma sadrži nevalidne podatke. Molimo ispravite i pokušajte ponovo"
    execute_script("arguments[0].click();", page.find("button.btn.cancel", visible: false))
    expect(page).to have_current_path('https://www.navigator.ba/#/categories', url: true)
    find('#ember566').click
    fill_in 'poi_name', with: 'Biljna apoteka'
    find_button('Odaberite kategoriju').click
    find('.span3 option[value="11"]').select_option
    find('.span3 option[value="203"]').select_option
    find_button('Odaberite kategoriju').native.send_keys(:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab )
    find_button("Kreiraj", visible: false).click
    expect(page).to have_text "Biljna apoteka"
  end

  it 'logo button'  do
    find('#ember566').click
    expect(page).to have_current_path('https://www.navigator.ba/#/create-place', url: true)
    find('.ember-view.logo').click
    expect(page).to have_current_path('https://www.navigator.ba/#/categories', url: true)
  end

  it 'invalid search' do
    fill_in "Traži ulicu ili objekat", with: '55555555'
    find('.iconav-search').click
    expect(page).to have_css('.no-results')
    expect(page).to have_text "Žao nam je. Nismo uspjeli pronaći niti jedan rezultat za traženu pretragu."
    expect(page).to have_button "Dodaj ovaj objekat"
  end

  it 'suggested cards' do
    find('.accommodation').click
    expect(page).to have_current_path('https://www.navigator.ba/#/categories/accommodation')
    expect(page).to have_content('Hotel')
    expect(page).to have_content('Hostel')
    expect(page).to have_content('Apartment')
    expect(page).to have_content('Pansion')
  end

  it 'view image' do
    fill_in "Traži ulicu ili objekat", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    find('.ember-view.profile-image-container').click
    expect(page).to have_css('.cboxPhoto')
    find('#cboxNext').click
    expect(page).to have_xpath('//*[@id="cboxLoadedContent"]/img')
    find('#cboxPrevious').click
    expect(page).to have_xpath('//*[@id="cboxLoadedContent"]/img')
  end

  it 'Google Play/App Store' do
    new_window = window_opened_by { find('.ember-view.apps-widget').click }
    within_window new_window do
        expect(page).to have_current_path('https://play.google.com/store/apps/details?id=com.atlantbh.navigator')
    end
  end

  it 'O Navigatoru' do
    click_link('O Navigatoru')
    expect(page).to have_current_path('https://www.navigator.ba/#/about')
  end

  it 'Leaflet' do
    click_link('Leaflet')
    expect(page).to have_current_path('https://leafletjs.com/')
  end

  it 'Atlantbh' do
    new_window = window_opened_by { click_link('© Atlantbh 2018 OSM contributors') }
    within_window new_window do
        expect(page).to have_current_path('https://www.atlantbh.com/')
    end
  end

  it 'search place and hover basic details' do
    fill_in "Traži ulicu ili objekat", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.marker-circle-container').hover
    expect(page).to have_css('.marker-popup')
    expect(page).to have_content('Kamerni teatar 55')
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    expect(page).to have_css '.leaflet-popup'
  end

  it 'search place English' do
    find('.en').click
    expect(page).to have_content('Create Place')
    fill_in "Search street or place", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    expect(page).to have_css '.leaflet-popup'
  end

  it 'send message' do
    find('#ember581').click
    fill_in "Ime i prezime", with: 'Medzida Mustafic'
    fill_in "Email", with: 'medzidamustafic@gmail.com'
    fill_in "Komentar", with: 'I like it!'
    find('.green').click
    click_button 'Pošalji'
    expect(page).to have_content "Hvala na poruci! Potrudit ćemo se da što prije reagujemo."
  end

  it 'claim place' do
    fill_in "Traži ulicu ili objekat", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    find('.ember-view.ember-text-field.tt-query').native.send_keys(:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab)
    execute_script("arguments[0].click();", page.find("button.btn-claim", visible: false))
    fill_in "Vaše ime", with: 'Medzida Mustafić'
    fill_in "Vaš email", with: 'medzida.mustafic@yahoo.com'
    fill_in "Vaš telefon", with: '+38761345567'
    click_button 'Pošalji'
    expect(page).to have_content('Poruka uspješno poslana. Navigator tim će Vas kontaktirati u roku od 48 sati')
  end

  it 'claim place English' do
    find('.en').click
    expect(page).to have_content('Create Place')
    fill_in "Search street or place", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    find('.ember-view.ember-text-field.tt-query').native.send_keys(:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab)
    execute_script("arguments[0].click();", page.find("button.btn-claim", visible: false))
    fill_in "Your name", with: 'Medzida Mustafić'
    fill_in "Your email", with: 'medzida.mustafic@yahoo.com'
    fill_in "Your phone number", with: '+38761345567'
    click_button 'Claim'
    expect(page).to have_content('Message successfully sent. Navigator team will get back to you in next 48 hours')
  end

  it 'rate place' do
    fill_in "Traži ulicu ili objekat", with: 'Kulturalna asocijacija AMBROSIA'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'http://www.ambrosia.ba/'
    find('.empty').hover
    execute_script("arguments[0].click();", page.find('[data-value="3"]'))
    expect(page).to have_content('5 ocjena')
  end

  it 'event cards' do
    fill_in "Traži ulicu ili objekat", with: 'Kulturalna asocijacija AMBROSIA'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_css('.events')
    expect(page).to have_css('.tooltip-events')
  end

  it 'suggest changes' do
    fill_in "Traži ulicu ili objekat", with: 'Kamerni teatar 55'
    find('.iconav-search').click
    find('.mCSB_container').click
    expect(page).to have_link 'www.kamerniteatar55.ba'
    find('.ember-view.ember-text-field.tt-query').native.send_keys(:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab)
    execute_script("arguments[0].click();", page.find("button.btn-success.btn-suggest-edit", visible: false))
    fill_in "poi_street_name_alt", with: 'Aleja Lipa 33'
    find_button('Odaberite kategoriju').native.send_keys(:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab,:tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab, :tab)
    execute_script("arguments[0].click();", page.find('button.btn-success'))
    def wait_until_modal
        page.has_css?('.alertify.alertify-alert')
    end
    expect(page).to have_content('Zahvaljujemo Vam na predloženim izmjenama. Vaše izmjene će biti vidljive nakon revizije.')
    find_button('OK').click
  end
end