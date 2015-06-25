subroutine vechme_wrap(stop     , modelz, lload_namez, lload_infoz, inst,&
                       cara_elem, mate  , vect_elemz , varc_currz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/vechme.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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
! person_in_charge: jacques.pellet at edf.fr
!
    character(len=1), intent(in) :: stop
    character(len=*), intent(in) :: modelz
    character(len=*), intent(in) :: lload_namez
    character(len=*), intent(in) :: lload_infoz
    real(kind=8), intent(in) :: inst(3)
    character(len=*), intent(in) :: cara_elem
    character(len=*), intent(in) :: mate
    character(len=*), intent(inout) :: vect_elemz
    character(len=*), intent(in) :: varc_currz
!
! --------------------------------------------------------------------------------------------------
!
! Compute Neumann loads
! 
! Dead and fixed loads
!
! --------------------------------------------------------------------------------------------------
!
! In  stop           : continue or stop computation if no loads on elements
! In  model          : name of model
! In  mate           : name of material characteristics (field)
! In  cara_elem      : name of elementary characteristics (field)
! In  lload_name     : name of object for list of loads name
! In  lload_info     : name of object for list of loads info
! In  inst           : times informations
! In  varc_curr      : command variable for current time
! IO  vect_elem      : name of vect_elem result
!
! ATTENTION :
!   LE VECT_ELEM (VECELZ) RESULTAT A 1 PARTICULARITE :
!   CERTAINS RESUELEM NE SONT PAS DES RESUELEM MAIS DES CHAM_NO (.VEASS)
!
! --------------------------------------------------------------------------------------------------
!
    call vechme(stop     , modelz, lload_namez, lload_infoz, inst        ,&
                cara_elem, mate  , vect_elemz , varc_currz = varc_currz)
!
end subroutine
