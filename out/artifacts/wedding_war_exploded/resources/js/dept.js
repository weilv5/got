(function($){
    $.fn.deptTree = function(options){
        var defaults = {
            div: "deptTree",
            url: "/deptList",
            useChecked: false
        };

        this.options = $.extend(defaults, options);
        var div = $("<div id='" + options.div +"'></div>");
        $(this).append(div);

        var that = this;
        this.deptData = [{
            text: '组织机构',
            id: "root",
            backColor: "#33cdee",
            color: "#fff"
        }];

        this.addData = function(deptId, data, depts){
            if(depts.length == 0)
                return;
            var length = data.length;
            for(var i = 0; i < length; i++){
                var node = data[i];
                if(deptId===node.id){
                    if(!node.nodes)
                        node.nodes = [];
                    var deptLength = depts.length;
                    for(var j = 0; j < deptLength; j++){
                        var dept = depts[j];
                        node.nodes.push({
                            text: dept.deptName,
                            id: dept.id,
                            selectable: true
                        })
                    }
                    return;
                }else{
                    if(node.nodes)
                        that.addData(deptId, node.nodes, depts);
                }
            }
        }

        this.loadDeptTree = function (event, data) {
            var params = {};
            if(data.id && data.id != "root"){
                that.selectedNodeId = data.id;
                params = {
                    parentDeptId: that.selectedNodeId
                };
            }
            else
                params = {};
            if(that.options.onclick){
                if(typeof that.options.onclick === "string"){
                    eval(that.options.onclick)
                }else{
                    that.options.onclick(data);
                }
            }

            $.ajax({
                url: that.options.url,
                data: params,
                type: "post",
                dataType: "json",
                success: function(depts){
                    if(!data.state.expanded && !data.nodes){
                        that.addData(data.id, that.deptData, depts);
                        $('#' + options.div).treeview("remove");
                        $('#' + options.div).treeview({
                            data: that.deptData,
                            showCheckbox: that.options.useChecked,
                            onNodeSelected: that.loadDeptTree,
                            onNodeChecked: that.options.onChecked
                        });
                    }
                    that.nodeId = data.nodeId;
                    setTimeout(function(){
                        var node = $('#' + options.div).treeview('getNode', that.nodeId);
                        if(node.nodes && node.nodes.length>0){
                            $('#' + options.div).treeview("revealNode", [node.nodes[0].nodeId]);
                        }
                        else{
                            $('#' + options.div).treeview("revealNode", [node.nodeId]);
                        }
                    }, 200);
                }
            });
        };

        $('#' + options.div).treeview({
            data: this.deptData,
            showCheckbox: this.options.useChecked,
            onNodeSelected: this.loadDeptTree,
            onNodeChecked: this.options.onChecked
        });
        this.loadDeptTree("", $('#' + options.div).treeview('getNode', 0));

    };
})(jQuery);