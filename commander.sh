#!/bin/bash

# Function to create or update an alias in zshrc with comments
update_zshrc() {
    local alias_name=$1
    local command=$2
    local comment=$3
    local zshrc_file=~/.zshrc

    # Escape special characters in the comment for sed
    comment=$(printf "%s" "$comment" | sed 's/[^a-zA-Z0-9]/\\&/g')

    # Check if the alias already exists in zshrc
    if grep -q "^alias $alias_name=" $zshrc_file; then
        sed -i "s/^alias $alias_name=.*$/alias $alias_name=\"$command\" # $comment/" $zshrc_file
        echo "Alias '$alias_name' updated in $zshrc_file."
    else
        echo "alias $alias_name=\"$command\" # $comment" >> $zshrc_file
        echo "Alias '$alias_name' added to $zshrc_file."
    fi
}

# Function to delete an alias from zshrc
delete_from_zshrc() {
    local alias_name=$1
    local zshrc_file=~/.zshrc

    # Delete the alias if it exists
    if grep -q "^alias $alias_name=" $zshrc_file; then
        sed -i "/^alias $alias_name=/d" $zshrc_file
        echo "Alias '$alias_name' deleted from $zshrc_file."
    else
        echo "Alias '$alias_name' not found in $zshrc_file."
    fi
}

# Function to list all aliases in zshrc with comments
list_zshrc() {
    local zshrc_file=~/.zshrc
    echo "List of aliases in $zshrc_file:"
    grep "^alias " $zshrc_file | sed -E 's/alias ([^=]*)="(.*)" # (.*)/\1: \2 (\3)/'
}

# Parse command line arguments
case $1 in
    "create")
        update_zshrc "$2" "$3" "$4"
        ;;
    "delete")
        delete_from_zshrc "$2"
        ;;
    "list")
        list_zshrc
        ;;
    *)
        echo "Usage: $0 [create|delete|list] [alias_name] [command] [comment]"
        ;;
esac

