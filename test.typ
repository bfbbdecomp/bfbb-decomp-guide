
- hey


#figure(
```cpp
void zActionLineRender()
{
    RwRenderStateSet(rwRENDERSTATETEXTURERASTER, sActionLineRaster);

    for (S32 i = 0; i < 8; i++)
    {
        // hey
        _tagActionLine* line = sActionLine[i];

        if (line && line->flags & 1)
        {
            RenderActionLine(line);
        }
    }
}
```,
caption: [hello world]
)