$(function(){
    $.post('html', function(d){
        console.log(d);
        $('#gallery-header-center-right').html('<div class="gallery-header-center-right-links gallery-header-center-right-links-current" data-filter="*">全部</div>');
        $('#gallery-content-center').html('');
        var sort = JSON.parse(d.sort);
        console.log(sort);
        for(var i in sort){
            $('#gallery-header-center-right').append('<div class="gallery-header-center-right-links" data-filter=".' + sort[i].key + '">' + sort[i].value + '</div>');
        }
        var list = d.list;
        for(var i in list){
            $('#gallery-content-center').append('<a class="col-md-4 ' + list[i].photoSort.split("|")[2] + '" href="' + list[i].photo + '" data-lightbox="studio1"><img src="' + list[i].photo + '" class="img-responsive"></a>');
        }
        // init Isotope
        var $grid = $('#gallery-content-center').isotope({
            // options
        });
        // filter items on button click
        $('.gallery-header-center-right-links').on( 'click', function() {

            $(".gallery-header-center-right-links").removeClass("gallery-header-center-right-links-current");
            $(this).addClass("gallery-header-center-right-links-current");

            var filterValue = $(this).attr('data-filter');
            $grid.isotope({ filter: filterValue });
        });
    });
});