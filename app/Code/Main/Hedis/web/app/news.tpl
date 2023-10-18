<ul>
    <li v-for="(story, index) in stories" :key="index">
        {{ story.id }} : {{ story.title }} 
        <br/>
        {{ story.content }}
    </li>
</ul>
        