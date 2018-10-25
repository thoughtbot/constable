import marked from 'marked'
import hljs from 'highlight.js'

marked.setOptions({
  highlight: (code) => {
    return hljs.highlightAuto(code).value
  }
})

const code_blocks = function() {
  return document.querySelectorAll('pre code')
}

export function highlightCodeBlocks() {
  code_blocks().forEach(function(block) {
    hljs.highlightBlock(block)
  })
}

export function markedWithSyntax(value) {
  return marked(value)
}
