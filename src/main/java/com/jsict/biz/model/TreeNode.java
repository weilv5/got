package com.jsict.biz.model;

import java.io.Serializable;
import java.util.List;

/**
 * Created by caron on 2017/6/5.
 */
public class TreeNode implements Serializable {

    private String text;

    private String moduleId;

    private String pid;

    private List<TreeNode> nodes;

    private TreeNodeState state;

    private boolean checked;

    private boolean open;

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getModuleId() {
        return moduleId;
    }

    public void setModuleId(String moduleId) {
        this.moduleId = moduleId;
    }

    public List<TreeNode> getNodes() {
        return nodes;
    }

    public void setNodes(List<TreeNode> nodes) {
        this.nodes = nodes;
    }

    public TreeNodeState getState() {
        return state;
    }

    public void setState(TreeNodeState state) {
        this.state = state;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public boolean isOpen() {
        return open;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }
}
