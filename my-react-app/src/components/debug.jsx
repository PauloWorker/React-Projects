function getColor(colorParam)
{
    let colorName = String(colorParam);

    const colors = [
        'red',
        'green',
        'blue'
    ];

    const findColor = colors.find(color => color === colorName);
    console.log(findColor);

    return findColor;
}



function Debug({ Color })
{
    const selectedColor = getColor(Color);

    return (
        <div>
            <p>Cor recebida: {Color}</p>
            <p>Cor encontrada: {selectedColor ? selectedColor : 'não encontrada'} </p>
        </div>
    );
}

export default Debug;