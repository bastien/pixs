// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function(){
  $('#sortingOptions #sortIMDB a').live('click', function(e){
    e.preventDefault();
    $('#sortIMDB').addClass('active');
    $('#sortAZ').removeClass('active');
    var sortParams =  
    { 
    sortOn: '.rating',
    direction: 'desc',
    sortType: 'number'
    }
    $('#filmList').sort(sortParams);
  });
  
  $('#sortingOptions #sortAZ a').live('click', function(e){
    e.preventDefault();
    $('#sortAZ').addClass('active');
    $('#sortIMDB').removeClass('active');
    var sortParams =  
    { 
    sortOn: '.title',
    direction: 'asc',
    sortType: 'string'
    }
    $('#filmList').sort(sortParams);
  });
  
  $('#dialog').dialog({
    autoOpen: false,
    height: 'auto',
    width: 'auto',
    resizable: false,
    draggable: false,
    modal: true 
  });
});