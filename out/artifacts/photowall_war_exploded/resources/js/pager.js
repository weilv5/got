(function($){
    $.fn.pagination = function(options){

        var defaults = {
            currPage: 1,
            totalPages: 0,
            totalRecords: 0,
            size:10,
            showPages: 5
        };
        $(this).empty();
        var options = $.extend(defaults, options);
        var nav = $('<nav aria-label="Page navigation">');
        var leftDiv = $("<div style='float: left; width: 50%;text-align: left;padding-left: 20px;margin: 5px 0px;'></div>");
        var rightDiv = $("<div style='float: right; width: 50%;padding-right: 20px; text-align: right;margin: 5px 0px;'></div>");
        var ul = $('<ul class="pagination" style="margin-bottom: 0px;margin-top: 0px;">');
        if(options.currPage>1){
            ul.append('<li><a href="#" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>');
        }
        var startPage = parseInt((options.currPage-1)/options.showPages) * options.showPages + 1;
        var endPage = parseInt(startPage + options.showPages);

        for(var page = startPage; page < endPage; page++){
            if(page>options.totalPages)
                break;
            if(page == options.currPage)
                ul.append('<li class="active"><a href="#">' + page + '</a></li>');
            else
                ul.append('<li><a href="#">' + page + '</a></li>');
        }
        if(options.currPage<options.totalPages){
            ul.append('<li><a href="#" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>');
        }
        nav.append(ul);
        $(rightDiv).append(nav);
        $(this).append(rightDiv);
        $(this).append(leftDiv);
        leftDiv.append("<div style=' height:34px; line-height: 34px;'>&nbsp;&nbsp;第&nbsp;<input type='number' value='" + options.currPage + "' style='width: 60px;border-radius: 4px;padding: 6px 12px;font-size: 14px;height:34px;border:1px solid #cccccc;background-color:#ffffff; ' >&nbsp;页( 总共 " + options.totalPages + " 页 " + options.totalRecords + " 条记录 )</div>");
        var that = this;
        $('input', this).keyup(function(e){
            if(e.key === "Enter"){
                options.currPage = e.target.value;
                if(options.currPage<options.totalPages)
                    options.loadData(options.currPage, options.size);
            }
        });
        $('li a', this).click(function(e){
            if(!$(this).attr("aria-label")){
                options.currPage = parseInt($(this).text());
            }else if($(this).attr("aria-label")==="Previous"){
                if(options.currPage>1){
                    options.currPage--;

                }
            }else if($(this).attr("aria-label")==="Next"){
                if(options.currPage<options.totalPages){
                    options.currPage++;
                }
            }
            $('li', that).removeClass("active");
            $('li :contains(' + options.currPage + ')', that).parent().addClass("active");

            options.loadData(options.currPage, options.size);
        });
    }
})(jQuery);
