subroutine ntload_chck(list_load)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: list_load
!
! --------------------------------------------------------------------------------------------------
!
! THER_LINEAIRE - Algorithm
!
! Check loads
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load        : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, i_load, nb_load
    aster_logical :: isnotallowed
    character(len=8) :: load_name
    character(len=19) :: cart_name
    character(len=24) :: lload_name, lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    isnotallowed = .false.
!
! - Datastructure access
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    call jeveuo(lload_name, 'L', vk24 = v_load_name)
    call jeveuo(lload_info, 'L', vi   = v_load_info)
!
! - Seek for special loads
!
    call jeexin(lload_name, iret)
    if (iret .ne. 0) then
        nb_load = v_load_info(1)
        if (nb_load .ne. 0) then
            do i_load = 1, nb_load
                load_name = v_load_name(i_load)
                cart_name = load_name(1:8)//'.CHTH'//'.CONVE'
                call jeexin(cart_name//'.VALE', iret)
                if (iret .ne. 0) then
                    isnotallowed = .true.
                endif    
            end do
        endif
    endif
!
! - Fatal error
!
    if (isnotallowed) then
        call utmess('F', 'THERNONLINE4_1')
    endif
!
end subroutine
