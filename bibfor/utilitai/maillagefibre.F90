! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine maillagefibre(nogfma, ulnbnoeuds, maxmailgrp, nbgf, vcoord, nbnoeuds, &
                         vigroup, vngroup, vmailgrp, vimailles, ulnbmailles, ncarma)
!
!
    implicit none
    character(len=8), intent(in) :: nogfma
    integer, intent(in) :: ulnbnoeuds, maxmailgrp, ulnbmailles, nbgf, ncarma, nbnoeuds
    real(kind=8), intent(in) :: vcoord(2*ulnbnoeuds)
    integer, intent(in) :: vigroup(nbgf*maxmailgrp)
    integer, intent(in) :: vmailgrp(nbgf)
    character(len=24), intent(in) :: vngroup(nbgf)
    integer, intent(in) :: vimailles(ulnbmailles*ncarma)
!
! --------------------------------------------------------------------------------------------------
!
!               Création de la SD maillage : GEOM_FIBRE
!
! --------------------------------------------------------------------------------------------------
!
!   nogfma      : Nom du maillage
!   ulnbnoeuds  : Nombre de noeuds maximun (pour dimension vcoord)
!   nbnoeuds    : Nombre de noeuds
!   nbgf        : Nombre de groupe
!   ulnbmailles : Nombre de mailles
!   maxmailgrp  : Le maximum de mailles dans un groupe
!   ncarma      : Nombre de caratéristiques par mailles (2 + nbde noeuds)
!
!   vcoord      :   Coordonnées des fibres dans la section droite, dimension 2.
!   vngroup     :   Nom des groupes de mailles
!   vmailgrp    :   Nombre de maille par groupe
!   vigroup     :   Liste des mailles des groupes.
!           Pour ième groupe [1..nbgf]
!                jème maille du groupe [1..vmailgrp(i)]
!           vigroup( (i-1)*maxmailgrp + j ) c'est la jème maille du ième groupe
!   vimailles   :   Table de connectivité des mailles
!           Mailles du type POI1 ou QUAD4 ou TRI3 : 4 noeuds ==> ncarma = 4 + 2
!           vimailles( (i-1)*ncarma + 1 )       : Type de la ième maille
!           vimailles( (i-1)*ncarma + 2 )       : Nombre de noeud de la ième maille
!           vimailles( (i-1)*ncarma + 2 + j )   : jème noeud de la ième maille
!
! --------------------------------------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/cargeo.h"
#include "asterfort/codent.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii, iadobj, idep, ifin, itype, nbmail, nno, nbnoma
    character(len=7)  :: k7bid
    character(len=24) :: objdime,   objtitre,  objnomnoe, objcooval, objcoodsc, objcooref
    character(len=24) :: objnommai, objtypmai, objconnex, objgrpmai, objgpptnm
    character(len=24) :: nomgrf
!
    integer, pointer            :: dime(:)  => null()
    real(kind=8), pointer       :: xyz(:)   => null()
    character(len=80), pointer  :: titre(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!   Construction des noms pour l'objet maillage
!                 123456789012345678901234
    objdime   = nogfma// '.DIME           '
    objtitre  = nogfma// '           .TITR'
    objnomnoe = nogfma// '.NOMNOE         '
    objcooval = nogfma// '.COORDO    .VALE'
    objcoodsc = nogfma// '.COORDO    .DESC'
    objcooref = nogfma// '.COORDO    .REFE'
    objnommai = nogfma// '.NOMMAI         '
    objtypmai = nogfma// '.TYPMAIL        '
    objconnex = nogfma// '.CONNEX         '
    objgrpmai = nogfma// '.GROUPEMA       '
    objgpptnm = nogfma// '.PTRNOMMAI      '
!
! --------------------------------------------------------------------------------------------------
!   Création de l'objet .dime
    call wkvect(objdime, 'G V I', 6, vi=dime)
    dime(1)= nbnoeuds
    dime(3)= ulnbmailles
    dime(6)= 2
!
! --------------------------------------------------------------------------------------------------
!   Création de l'objet .titr
    call wkvect(objtitre, 'G V K80', 4, vk80=titre)
    write(titre(1),'(A)')    ' Maillage des fibres'
    write(titre(2),'(A,I8)') '   Nb Noeuds  ',nbnoeuds
    write(titre(3),'(A,I8)') '   Nb Mailles ',ulnbmailles
    write(titre(4),'(A,I8)') '   Nb Groupes ',nbgf
!
! --------------------------------------------------------------------------------------------------
!   Pour les NOEUDS
!
!   Répertoire noms de noeuds
    call jecreo(objnomnoe, 'G N K8')
    call jeecra(objnomnoe, 'NOMMAX', nbnoeuds)
!
!   Numéro identifiant le type de cham_no géométrie
    call jenonu(jexnom('&CATA.GD.NOMGD', 'GEOM_R'), itype)
    call jecreo(objcoodsc, 'G V I')
    call jeecra(objcoodsc, 'LONMAX', 3)
    call jeecra(objcoodsc, 'DOCU', 0, 'CHNO')
    call jeveuo(objcoodsc, 'E', iadobj)
    zi(iadobj) = itype
    zi(iadobj+1) = -3
    zi(iadobj+2) = 14
!
!   nom du maillage
    call wkvect(objcooref, 'G V K24', 4, iadobj)
    zk24(iadobj) = nogfma
!
    call wkvect(objcooval, 'G V R', 3*nbnoeuds, vr=xyz)
!
!   Remplissage du répertoire des noms des noeuds et des coordonnées
    do ii = 1, nbnoeuds
        call codent(ii, 'G', k7bid )
        call jecroc(jexnom(objnomnoe, 'N'//k7bid))
        xyz(3*ii-2) = vcoord(2*ii-1)
        xyz(3*ii-1) = vcoord(2*ii)
    enddo
!
! --------------------------------------------------------------------------------------------------
!   Pour les MAILLES
!
!   Répertoire noms de mailles
    call jecreo(objnommai, 'G N K8')
    call jeecra(objnommai, 'NOMMAX', ulnbmailles)
!
!   Type de mailles
    call jecreo(objtypmai, 'G V I')
    call jeecra(objtypmai, 'LONMAX', ulnbmailles)
    call jeveuo(objtypmai, 'E', itype)
!
!   Connectivité
    call jecrec(objconnex, 'G V I', 'NU', 'CONTIG', 'VARIABLE', ulnbmailles)
    nbnoma = 0
    do ii=1, ulnbmailles
        nbnoma = nbnoma + vimailles( (ii-1)*ncarma+2 )
    enddo
    call jeecra(objconnex, 'LONT', nbnoma)
!
    do ii=1, ulnbmailles
        call codent(ii,'G',k7bid)
        call jecroc(jexnom(objnommai,'M'//k7bid))
        nno = vimailles( (ii-1)*ncarma+2 )
        call jeecra(jexnum(objconnex,ii), 'LONMAX', nno)
        call jeveuo(jexnum(objconnex,ii), 'E', iadobj)
        zi(itype+ii-1) = vimailles( (ii-1)*ncarma+1 )
        zi(iadobj:iadobj+nno-1) = vimailles( (ii-1)*ncarma+3:(ii-1)*ncarma+2+nno )
    enddo
!
! --------------------------------------------------------------------------------------------------
!   Pour les GROUPES DE MAILLES
!
!   Répertoire noms des groupes de mailles
    call jecreo(objgpptnm, 'G N K24')
    call jeecra(objgpptnm, 'NOMMAX', nbgf)
!   Groupe de maille
    call jecrec(objgrpmai, 'G V I', 'NO '//objgpptnm, 'DISPERSE', 'VARIABLE',nbgf)
!
!   Les groupes de mailles
    do ii = 1 , nbgf
        nbmail = vmailgrp(ii)
        idep = (ii-1)*maxmailgrp+1
        ifin = (ii-1)*maxmailgrp+nbmail
        nomgrf = vngroup(ii)
        call jecroc(jexnom(objgrpmai, nomgrf))
        call jeecra(jexnom(objgrpmai, nomgrf), 'LONMAX', nbmail)
        call jeecra(jexnom(objgrpmai, nomgrf), 'LONUTI', nbmail)
!       Les mailles du groupes
        call jeveuo(jexnom(objgrpmai, nomgrf), 'E', iadobj)
        zi(iadobj:iadobj+nbmail-1) = vigroup(idep:ifin )
    enddo
!   Caractéristiques géométriques
    call cargeo(nogfma)
!
    call jedema()
end subroutine
