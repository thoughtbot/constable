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

const initializeSyntaxHighlighting = _container => {
  highlightCodeBlocks();
};

const highlightCodeBlocks = function() {
  $('pre code').each(function(_index, block) {
    hljs.highlightBlock(block);
  });
};

export function markedWithSyntax(value) {
  return marked(value);
}

export function highlightSyntax(container) {
  observer.observe(document.querySelector(container), { childList: true });
  initializeSyntaxHighlighting(container);
}
