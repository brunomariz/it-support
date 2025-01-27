setup_isos() {
    # Cria os diretórios
    for i in {1..4}; do
        mkdir -p {{ ANSYS_MNT_PATH}}/disk$i
    done

    # Monta as ISOs
    mount {{ ANSYS_DISK1_PATH }} {{ ANSYS_MNT_PATH}}/disk1
    mount {{ ANSYS_DISK2_PATH }} {{ ANSYS_MNT_PATH}}/disk2
    mount {{ ANSYS_DISK3_PATH }} {{ ANSYS_MNT_PATH}}/disk3
    mount {{ ANSYS_DISK4_PATH }} {{ ANSYS_MNT_PATH}}/disk4
}

setup_isos
