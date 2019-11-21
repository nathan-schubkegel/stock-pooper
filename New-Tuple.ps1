function New-Tuple([object[]]$list = $(throw "Please specify the list of names and values")) {
  $tuple = new-object psobject
  for ( $i= 0 ; $i -lt $list.Length; $i = $i+2)
  {
    $name = [string]($list[$i])
    $value = $list[$i+1]
    $tuple | add-member NoteProperty $name $value
  }
  return $tuple
}
