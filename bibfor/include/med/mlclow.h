!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
!
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
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
interface
#include "asterf_types.h"
    subroutine mlclow(fid, lname, gtype, sdim, ecoo,&
                      swm, nip, ipcoo, wght, giname,&
                      isname, cret)
        med_int :: fid
        character(len=*) :: lname
        med_int :: gtype
        med_int :: sdim
        real(kind=8) :: ecoo(*)
        med_int :: swm
        med_int :: nip
        real(kind=8) :: ipcoo(*)
        real(kind=8) :: wght(*)
        character(len=*) :: giname
        character(len=*) :: isname
        med_int :: cret
    end subroutine mlclow
end interface
