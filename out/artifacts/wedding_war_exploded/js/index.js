var $photo = (function() {

    function init(d){
        $('#gallery-header-center-right').html('');
        $('#gallery-content-center').html('');
        $('#gallery-header-center-right').html('<div class="gallery-header-center-right-links gallery-header-center-right-links-current" data-filter="*">全部</div>');
        var sort = JSON.parse(d.photoSort);
        for(var i in sort){
            $('#gallery-header-center-right').append('<div class="gallery-header-center-right-links" data-filter=".' + sort[i].key + '">' + sort[i].value + '</div>');
        }
        var list = d.list;
        for(var i in list){
            $('#gallery-content-center').append('<a class="col-md-4 ' + list[i].photoSort.split("|")[2] + '" href="' + list[i].photo + '" data-lightbox="studio1"><img src="' + list[i].photo + '" class="img-responsive"></a>');
        }
    }

    function sortClick(){
        // filter items on button click
        $('.gallery-header-center-right-links').on( 'click', function() {

            $(".gallery-header-center-right-links").removeClass("gallery-header-center-right-links-current");
            $(this).addClass("gallery-header-center-right-links-current");

            var filterValue = $(this).attr('data-filter');
            $('#gallery-content-center').isotope({ filter: filterValue });
        });
    }

    function albumName(album){
        if(album == 'jhz') return '结婚照相册';
        if(album == 'xt') return '喜糖相册';
        if(album == 'hlt') return '婚礼堂相册';
    }

    return function (album) {
        // $('#gallery-header-center-left-title').html(albumName(album));
        $.post('html', {album: album}, function (d) {
            console.log(d);
            init(d);
            sortClick();
        });
    }

}());

