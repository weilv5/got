package com.jsict.biz.sensitive;

import com.jsict.biz.model.SensitiveWords;
import com.jsict.biz.service.SensitiveWordsService;
import com.jsict.framework.core.sensitive.processer.Processer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * <p>功能：基于正则表达式的敏感词过滤器</p>
 * Created by chensy on 2017/3/29 17:02.
 * version: 1.0
 */
@Service
public class ExpProcesser implements Processer{

    @Autowired
    SensitiveWordsService sensitiveWordsService;

    /**
     * isContain用于检查文本是否存在敏感词，可参照replace的实现
     * @param content 需要被检查的文本
     * @return
     */
    @Override
    public boolean isContain(String content) {
        return  false;
    }

    @Override
    public String replace(String content, String replaceStr) {

        List<Integer> startPositions = new ArrayList<>();
        List<Integer> endPositions = new ArrayList<>();

        List<SensitiveWords> wordList = sensitiveWordsService.loadAllWords();

        StringBuilder stringBuilder = new StringBuilder("(");
        stringBuilder.append(wordList.get(0).getWords());
        for(int i = 1; i < wordList.size(); i++){
            stringBuilder.append("|" + wordList.get(i).getWords());
        }
        stringBuilder.append(")");
        Pattern pattern = Pattern.compile(stringBuilder.toString());

        StringBuilder sb = new StringBuilder(content);
        Matcher matcher = pattern.matcher(content);
        while(matcher.find()) {
            startPositions.add(matcher.start());
            endPositions.add(matcher.end());
        }
        for(int i = startPositions.size()-1; i >= 0; i--){
            sb.replace(startPositions.get(i), endPositions.get(i), replaceStr);
        }

        return sb.toString();
    }

}
