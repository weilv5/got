(function($){
    $.fn.roleTree = function(options){
        var defaults = {
            div: "roleTree",
            url: "/role/list",
            useChecked: false,
            onUnChecked: function(event, role){}
        };

        this.options = $.extend(defaults, options);
        var div = $("<div id='" + this.options.div +"'></div>");
        $(this).append(div);

        var that = this;
        this.roleData = [{
            text: '角色',
            id: "root",
            backColor: "#33cdee",
            color: "#fff"
        }];

        this.addData = function(roleId, data, roles){
            if(roles.length == 0)
                return;
            var length = data.length;
            for(var i = 0; i < length; i++){
                var node = data[i];
                if(roleId===node.id){
                    if(!node.nodes)
                        node.nodes = [];
                    var roleLength = roles.length;
                    for(var j = 0; j < roleLength; j++){
                        var role = roles[j];
                        node.nodes.push({
                            text: role.roleName,
                            id: role.id,
                            selectable: true
                        })
                    }
                    return;
                }else{
                    if(node.nodes)
                        that.addData(roleId, node.nodes, roles);
                }
            }
        }

        this.loadRoleTree = function (event, data) {
            var params = {};
            if(data.id && data.id != "root"){
                that.selectedNodeId = data.id;
                params = {
                    parentRoleId: that.selectedNodeId
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
                success: function(roles){
                    if(!data.state.expanded && !data.nodes){
                        that.addData(data.id, that.roleData, roles);
                        $('#' + that.options.div).treeview("remove");
                        $('#' + that.options.div).treeview({
                            data: that.roleData,
                            showCheckbox: that.options.useChecked,
                            onNodeSelected: that.loadRoleTree,
                            onNodeChecked: that.options.onChecked,
                            onNodeUnchecked: that.options.onUnChecked
                        });
                    }
                    that.nodeId = data.nodeId;
                    setTimeout(function(){
                        var node = $('#' + that.options.div).treeview('getNode', that.nodeId);
                        if(node.nodes && node.nodes.length>0){
                            $('#' + that.options.div).treeview("revealNode", [node.nodes[0].nodeId]);
                        }
                        else{
                            $('#' + that.options.div).treeview("revealNode", [node.nodeId]);
                        }
                    }, 200);
                }
            });
        };

        $('#' + this.options.div).treeview({
            data: this.roleData,
            showCheckbox: this.options.useChecked,
            onNodeSelected: this.loadRoleTree,
            onNodeChecked: this.options.onChecked,
            onNodeUnchecked: this.options.onUnChecked
        });
        this.loadRoleTree("", $('#' + this.options.div).treeview('getNode', 0));

    };
})(jQuery);