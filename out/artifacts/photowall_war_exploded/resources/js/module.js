(function($){
    $.fn.moduleTree = function(options){
        var defaults = {
            div: "moduleTree",
            url: "/module/list",
            useChecked: false
        };

        this.options = $.extend(defaults, options);
        var div = $("<div id='" + options.div +"'></div>");
        $(this).append(div);

        var that = this;
        this.moduleData = [{
            text: '模块',
            id: "root",
            backColor: "#33cdee",
            color: "#fff"
        }];

        this.addData = function(moduleId, data, modules){
            if(modules.length > 0){
                var length = data.length;
                for(var i = 0; i < length; i++){
                    var node = data[i];
                    if(moduleId===node.id){
                        if(!node.nodes)
                            node.nodes = [];
                        var moduleLength = modules.length;
                        for(var j = 0; j < moduleLength; j++){
                            var module = modules[j];
                            node.nodes.push({
                                text: module.moduleName,
                                id: module.id,
                                selectable: true
                            })
                        }
                        return;
                    }else{
                        if(node.nodes)
                            that.addData(moduleId, node.nodes, modules);
                    }
                }
            }
        }

        this.loadModuleTree = function (event, data) {
            var params = {};
            if(data.id && data.id != "root"){
                that.selectedNodeId = data.id;
                params = {
                    parentModuleId: that.selectedNodeId
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
                success: function(modules){
                    if(!data.state.expanded && !data.nodes){
                        that.addData(data.id, that.moduleData, modules);
                        $('#' + options.div).treeview("remove");
                        $('#' + options.div).treeview({
                            data: that.moduleData,
                            showCheckbox: that.options.useChecked,
                            onNodeSelected: that.loadModuleTree,
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
                            $('#' + options.div).treeview("revealNode", [that.nodeId]);
                        }
                    }, 200);
                }
            });
        };

        $('#' + options.div).treeview({
            data: this.moduleData,
            showCheckbox: this.options.useChecked,
            onNodeSelected: this.loadModuleTree,
            onNodeChecked: this.options.onChecked
        });
        this.loadModuleTree("", $('#' + options.div).treeview('getNode', 0));

    };
})(jQuery);