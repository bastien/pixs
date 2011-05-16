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
    modal: true,
    close: function(event, ui){ $('#dialog').html("");}
  });
  
  $('#advancedFormLink').live('click', function(e){
    $('#advancedForm').toggle();
  });
});

function addRemoveProjection(new_projection) {
  // Add task
  $('.addProjection').click(function(event) {
    event.preventDefault();
    var new_id = new Date().getTime();
    var regexp = new RegExp('new_projection', 'g');
    $(this).parent().before(new_projection.replace(regexp, new_id));
    $(this).parent().prev().find('input:first').focus();
  });
  
  // Remove task
  $('.removeProjection').live('click', function(event) {
    event.preventDefault();
    $(this).closest('.inputs').find('input[type=hidden]').val('1');
    $(this).closest('.inputs').hide();
  });
}