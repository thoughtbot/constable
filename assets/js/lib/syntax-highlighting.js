import $ from 'jquery';
import marked from 'marked';
import hljs from 'highlight.js';

marked.setOptions({
  highlight: (code) => {
    return hljs.highlightAuto(code).value;
  },
});

const observer = new MutationObserver(mutations => {
  mutations.forEach((_mutation) => {
    highlightCodeBlocks();
  });
});

const initializeSyntaxHighlighting = (_container) => {
  highlightCodeBlocks();
};

const highlightCodeBlocks = () => {
  $('pre code').each((_index, block) => {
    hljs.highlightBlock(block);
  });
};

export const markedWithSyntax = (value) => {
  return marked(value);
};

export const highlightSyntax = (container) => {
  observer.observe(document.querySelector(container), { childList: true });
  initializeSyntaxHighlighting(container);
};
