subroutine wkvectc(nom, carac, dim, pc)
! ======================================================================
! COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
! aslint: disable=W1304
    use iso_c_binding, only: c_loc, c_ptr, c_f_pointer
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jecreo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/assert.h"
#include "asterfort/jgetptc.h"
!
    character(len=*), intent(in) :: nom
    character(len=*), intent(in) :: carac
    integer, intent(in) :: dim
    integer :: jadr
!
    aster_logical,     pointer :: vl(:)
    integer,           pointer :: vi(:)
    integer(kind=4),   pointer :: vi4(:)
    real(kind=8),      pointer :: vr(:)
    complex(kind=8),   pointer :: vc(:)
    character(len=8),  pointer :: vk8(:)
    character(len=16), pointer :: vk16(:)
    character(len=24), pointer :: vk24(:)
    character(len=32), pointer :: vk32(:)
    character(len=80), pointer :: vk80(:)
!
!
! ------------------------------------------------------------------
! Creation d'un vecteur jeveux
! ------------------------------------------------------------------
! in  nom   : ch*24 : nom du vecteur jeveux
! in  carac : ch    : descrivion des caracteristiques pour jecreo
! in  dim   : is    : taille du vecteur
! out jadr  : is    : adresse de l'objet dans ZI, ZR ...
! out vl   : l     : vecteur de logiques
! out vi   : i     : vecteur d'entiers
! ...
! Deux usages differents :
! ------------------------
! 1) recuperation de l'adresse de l'objet 'XXX' (jxxx) dans les COMMON zi, zr, ... :
!    call wkvect('XXX', 'V V R', 10, jxxx)
! 2) recuperation du contenu de l'objet 'XXX' dans le vecteur XXX
!    call wkvect('XXX', 'V V R', 10, vr=XXX)
!-----------------------------------------------------------------------
    integer :: jad
    character(len=8) :: ktyp
    type(c_ptr) :: pc
!---------------------------------------------------------------------------
    call jecreo(nom, carac)
    call jeecra(nom, 'LONMAX', ival=dim)
    call jeecra(nom, 'LONUTI', ival=dim)
    call jeveuo(nom, 'E', jad)
!
!
!     -- cas : on veut l'adresse
!
!
!     -- cas : on veut un pointeur
    call jelira(nom, 'TYPELONG', cval=ktyp)
    if (ktyp.eq.'L') then
        call jgetptc(jad, pc, vl=zl(1))
!
    else if (ktyp.eq.'I') then
        call jgetptc(jad, pc, vi=zi(1))
!
    else if (ktyp.eq.'S') then
        call jgetptc(jad, pc, vi4=zi4(1))
!
    else if (ktyp.eq.'R') then
        call jgetptc(jad, pc, vr=zr(1))
!
    else if (ktyp.eq.'C') then
        call jgetptc(jad, pc, vc=zc(1))
!
    else if (ktyp.eq.'K8') then
        call jgetptc(jad, pc, vk8=zk8(1))
!
    else if (ktyp.eq.'K16') then
        call jgetptc(jad, pc, vk16=zk16(1))
!
    else if (ktyp.eq.'K24') then
        call jgetptc(jad, pc, vk24=zk24(1))
!
    else if (ktyp.eq.'K32') then
        call jgetptc(jad, pc, vk32=zk32(1))
!
    else if (ktyp.eq.'K80') then
        call jgetptc(jad, pc, vk80=zk80(1))
!
    else
        ASSERT(.false.)
    endif
!
999 continue
!
end subroutine
