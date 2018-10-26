import marked from 'marked'
import hljs from 'highlight.js'

marked.setOptions({
  highlight: (code) => {
    return hljs.highlightAuto(code).value
  }
})

const codeBlocks = function () {
  return document.querySelectorAll('pre code')
}

export function highlightCodeBlocks () {
  codeBlocks().forEach(function (block) {
    hljs.highlightBlock(block)
  })
}

export function markedWithSyntax (value) {
  return marked(value)
}
